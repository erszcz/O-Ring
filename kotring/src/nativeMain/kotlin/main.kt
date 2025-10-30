import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import kotlin.time.measureTime

typealias ChanT = Channel<Int>

suspend fun createRing(n: Int, scope: CoroutineScope): Pair<ChanT, ChanT> {
    val startChannel: ChanT = Channel(Channel.RENDEZVOUS)

    val node = { src: ChanT, dst: ChanT ->
        scope.launch {
            for (x in src) {
                dst.send(x + 1)
            }
        }
    }

    var src = startChannel
    for (i in 0 until n) {
        val dst: ChanT = Channel(1)
        node(src, dst)
        src = dst
    }

    return Pair(startChannel, src)
}

fun main(args: Array<String>) {
    if (args.size != 2) {
        println("./ring N:<number of process> M:<trips>")
        return
    }

    val n = args[0].toIntOrNull()
    if (n == null) {
        println("cannot parse number of process")
        return
    }

    val m = args[1].toIntOrNull()
    if (m == null) {
        println("cannot parse number of trips")
        return
    }

    runBlocking {
        lateinit var ring: Pair<ChanT, ChanT>
        val t0 = measureTime {
            ring = createRing(n, this)
        }.inWholeMilliseconds

        var total = 0
        val t1 = measureTime {
            for (i in 0 until m) {
                ring.first.send(0)
                total += ring.second.receive()
            }
        }.inWholeMilliseconds

        if (total != (n * m)) {
            println("Ring failed!")
        }

        println("$t0 $t1 $n $m")
        coroutineContext.cancelChildren()
    }
}
