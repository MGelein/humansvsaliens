import { LightsService } from './lights.service';
export declare class LightsController {
    private readonly lightsService;
    constructor(lightsService: LightsService);
    get(id: any): number;
}
