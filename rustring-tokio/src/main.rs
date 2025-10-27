use anyhow::{Result};
//use futures_util::{StreamExt};
use std::env;
use std::time::Instant;
use tokio::sync::mpsc::{self, Receiver, Sender};
use tokio::task::{self, JoinHandle};

#[tokio::main]
async fn main() -> Result<()> {
    let args: Vec<String> = env::args().collect();

    if args.len() != 3 {
        panic!("./ring N:<number of process> M:<trips>");
    }

    let n: u64 = args[1].parse()?;
    let m: u64 = args[2].parse()?;

    let start = Instant::now();
    let (tx, mut rx, _tasks) = create_ring(n);
    let creation_time = start.elapsed();

    let (elapsed_time, total) = task::spawn(async move {
        let start = Instant::now();
        let mut total = 0;
        for _ in 0..m {
            tx.send(0).await.expect("It should send the initial message");
            let received = rx.recv().await.expect("It should receive a value");
            total += received;
        }
        (start.elapsed(), total)
    }).await?;

    if total != n * m {
        panic!("Ring failed")
    }

    println!(
        "{:?} {:?} {} {}",
        creation_time.as_millis(),
        elapsed_time.as_millis(),
        n,
        m
    );

    Ok(())
}

fn create_ring(n: u64) -> (Sender<u64>, Receiver<u64>, Vec<JoinHandle<()>>) {
    let (tx, rx) = mpsc::channel(1);
    let mut prev_r = rx;
    let mut tasks = Vec::with_capacity(n as usize);
    for _ in 0..n {
        let (t, r): (Sender<u64>, Receiver<u64>) = mpsc::channel(1);
        let task = task::spawn(async move {
            loop {
                match prev_r.recv().await {
                    Some(m) => {
                        t.send(m + 1).await.expect("It should send a ring message");
                    }
                    None => {
                        break;
                    }
                }
            }
        });
        tasks.push(task);
        prev_r = r;
    }
    return (tx, prev_r, tasks);
}
