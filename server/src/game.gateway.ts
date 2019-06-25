import { SubscribeMessage, WebSocketGateway, WebSocketServer, WsResponse, } from '@nestjs/websockets';
import { Client, Server } from 'socket.io';
  
@WebSocketGateway(9995, { namespace: 'game' })
export class GameGateway {

    @WebSocketServer()
    server: Server

    @SubscribeMessage('ping')
    async identity(client: Client, data: number): Promise<string> {
        return 'pong'
    }

}
