import { Injectable } from '@nestjs/common'

export interface Person {
    id: number,
    x: number,
    y: number,
    w: number,
    h: number
}

@Injectable()
export class PeopleService {

  people: Person[] = []

  list(): Person[] {
    return this.people
  }

  update(newPeople: Person[]): boolean {
    this.people = newPeople
    return true
  }

}
