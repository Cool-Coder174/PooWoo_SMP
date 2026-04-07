"""
TCP tunnel for PooWoo SMP.

LOCAL TEST (port forwarder - proves connectivity through a different port):
  python tunnel.py --forward --listen 25566 --target 127.0.0.1:25565

  Then connect Minecraft to localhost:25566 to verify it reaches the server.

PRODUCTION: Use rathole on your Linux VPS (see rathole/README-TUNNEL.md).
"""

import argparse
import asyncio
import signal
import sys

active_connections = 0


async def pipe(tag, reader, writer):
    try:
        while True:
            data = await reader.read(16384)
            if not data:
                break
            writer.write(data)
            await writer.drain()
    except (ConnectionResetError, BrokenPipeError, asyncio.CancelledError, OSError):
        pass
    finally:
        try:
            writer.close()
        except Exception:
            pass


async def handle_connection(client_reader, client_writer, target_host, target_port):
    global active_connections
    active_connections += 1
    addr = client_writer.get_extra_info("peername")
    print(f"[tunnel] Connection #{active_connections} from {addr[0]}:{addr[1]}")

    try:
        server_reader, server_writer = await asyncio.open_connection(target_host, target_port)
    except ConnectionRefusedError:
        print(f"[tunnel] Target {target_host}:{target_port} refused connection - is Minecraft running?")
        client_writer.close()
        active_connections -= 1
        return
    except OSError as e:
        print(f"[tunnel] Cannot reach {target_host}:{target_port}: {e}")
        client_writer.close()
        active_connections -= 1
        return

    print(f"[tunnel] Forwarding {addr[0]}:{addr[1]} <-> {target_host}:{target_port}")

    await asyncio.gather(
        pipe("client->server", client_reader, server_writer),
        pipe("server->client", server_reader, client_writer),
    )

    active_connections -= 1
    print(f"[tunnel] Connection from {addr[0]}:{addr[1]} closed ({active_connections} active)")


async def run_forward(listen_port, target_host, target_port):
    async def on_connect(reader, writer):
        asyncio.create_task(handle_connection(reader, writer, target_host, target_port))

    server = await asyncio.start_server(on_connect, "127.0.0.1", listen_port)
    print(f"=== PooWoo SMP Tunnel ===")
    print(f"Listening on 127.0.0.1:{listen_port}")
    print(f"Forwarding to {target_host}:{target_port}")
    print(f"")
    print(f"Connect Minecraft to: localhost:{listen_port}")
    print(f"Press Ctrl+C to stop")
    print()

    await server.serve_forever()


def main():
    parser = argparse.ArgumentParser(description="PooWoo SMP TCP Tunnel")
    parser.add_argument("--forward", action="store_true", required=True, help="Run as port forwarder")
    parser.add_argument("--listen", type=int, default=25566, help="Port to listen on (default: 25566)")
    parser.add_argument("--target", default="127.0.0.1:25565", help="Target address (default: 127.0.0.1:25565)")
    args = parser.parse_args()

    target_host, target_port = args.target.rsplit(":", 1)
    target_port = int(target_port)

    try:
        asyncio.run(run_forward(args.listen, target_host, target_port))
    except KeyboardInterrupt:
        print("\n[tunnel] Shutting down.")


if __name__ == "__main__":
    main()
