import asyncio
import websockets


async def ping(websocket,path):
    name = await websocket.recv()
    print(f"< {name}")
    
    greeting = 'ack'

    await websocket.send(greeting)
    print(f"> {greeting}")

start_server = websockets.serve(ping,"localhost",8080)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()

