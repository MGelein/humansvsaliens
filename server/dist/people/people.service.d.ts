export interface Person {
    id: number;
    x: number;
    y: number;
    w: number;
    h: number;
}
export declare class PeopleService {
    people: Person[];
    list(): Person[];
    update(newPeople: Person[]): boolean;
}
