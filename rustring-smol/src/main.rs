use macro_rules_attribute::apply;
use smol_macros::main;
use smol::{channel, Executor, Task};
use smol::channel::{Receiver, Sender};
use std::env;
use std::sync::Arc;
use std::time::Instant;

#[apply(main!)]
async fn main(ex: Arc<Executor>) {
    let args: Vec<String> = env::args().collect();

    if args.len() != 3 {
        panic!("./ring N:<number of process> M:<trips>");
    }

    let n: u64 = args[1].parse().expect("Cannot parse number of process");
    let m: u64 = args[2].parse().expect("Cannot parse number of trips");

    let start = Instant::now();
    let (tx, rx, _tasks) = create_ring(ex.clone(), n);
    let creation_time = start.elapsed();

    let (elapsed_time, total) = ex.spawn(async move {
        let start = Instant::now();
        let mut total = 0;
        for _ in 0..m {
            tx.send(0).await.expect("It should send the initial message");
            let received = rx.recv().await.expect("It should receive a value");
            total += received;
        }
        (start.elapsed(), total)
    }).await;

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
}

fn create_ring(ex: Arc<Executor>, n: u64) -> (Sender<u64>, Receiver<u64>, Vec<Task<()>>) {
    let (tx, mut rx) = channel::bounded(1);

    let mut tasks = Vec::with_capacity(n as usize);
    for _ in 0..n {
        let (t, r): (Sender<u64>, Receiver<u64>) = channel::bounded(1);
        let inner_r = rx.clone();
        let task = ex.spawn(async move {
            loop {
                match inner_r.recv().await {
                    Ok(m) => {
                        t.send(m + 1).await.expect("It should send a ring message");
                    }
                    Err(_) => {
                        break;
                    }
                }
            }
        });
        tasks.push(task);
        rx = r;
    }
    return (tx, rx, tasks);
}
