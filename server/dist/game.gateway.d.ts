import { Client, Server } from 'socket.io';
export declare class GameGateway {
    server: Server;
    identity(client: Client, data: number): Promise<string>;
}
