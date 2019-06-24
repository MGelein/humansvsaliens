import { ProgressService } from './progress/progress.service';
import { LightsService } from './lights/lights.service';
import { PeopleService } from './people/people.service';
export declare class AppController {
    private readonly progressService;
    private readonly lightsService;
    private readonly peopleService;
    constructor(progressService: ProgressService, lightsService: LightsService, peopleService: PeopleService);
    index(): any;
}
