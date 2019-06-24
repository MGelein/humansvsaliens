import { ProgressService } from './progress.service';
export declare class ProgressController {
    private readonly progressService;
    constructor(progressService: ProgressService);
    get(): number;
    update(body: string): boolean;
}
