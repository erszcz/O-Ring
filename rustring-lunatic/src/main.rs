use std::env;
use std::time::Instant;
use lunatic::{Mailbox, Process};

#[lunatic::main]
fn main(mailbox: Mailbox<u64>) {
    let args: Vec<String> = env::args().collect();

    if args.len() != 3 {
        panic!("./ring N:<number of process> M:<trips>");
    }

    let n: u64 = args[1].parse().unwrap();
    let m: u64 = args[2].parse().unwrap();

    let start = Instant::now();
    let ring = create_ring(mailbox.this(), n);
    let creation_time = start.elapsed();

    let start = Instant::now();
    let mut total = 0;
    for _ in 0..m {
        ring.send(0);
        let received = mailbox.receive();
        total += received;
    }
    let total = total;
    let elapsed_time = start.elapsed();

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

fn create_ring(this: Process<u64>, n: u64) -> Process<u64> {
    chain(this, n)
}

fn chain(parent: Process<u64>, n: u64) -> Process<u64> {
    if n == 0 {
        return parent;
    } else {
        let new = Process::spawn(parent, process);
        chain(new, n - 1)
    }
}

fn process(dest: Process<u64>, mailbox: Mailbox<u64>) {
    loop {
        let msg = mailbox.receive();
        dest.send(msg + 1);
    }
}
