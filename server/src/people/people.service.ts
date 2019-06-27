import { Injectable } from '@nestjs/common'

export interface Person {
    id: number,
    x: number,
    y: number,
    w: number,
    h: number
}

const TTLInSeconds = 500

@Injectable()
export class PeopleService {

  people: Person[] = []

  lastUpdated: Date = new Date()

  list(): Person[] {
    if ((Date.now() - this.lastUpdated.getTime()) < TTLInSeconds * 1000) return this.people
    return []
  }

  update(newPeople: Person[]): boolean {
    this.people = newPeople
    return true
  }

}
