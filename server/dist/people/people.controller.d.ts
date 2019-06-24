import { PeopleService, Person } from './people.service';
export declare class PeopleController {
    private readonly peopleService;
    constructor(peopleService: PeopleService);
    list(): Person[];
    csv(): string;
    update(body: any): boolean;
}
