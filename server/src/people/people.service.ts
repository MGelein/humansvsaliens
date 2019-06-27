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
  lastUpdated: Date = new Date()
  highestCountSinceReset: number = 0

  private enableTtl: boolean = false
  private ttlInSeconds: number = 5

  list(): Person[] {
    if (!this.enableTtl || (Date.now() - this.lastUpdated.getTime()) < this.ttlInSeconds * 1000) return this.people
    return []
  }

  update(newPeople: Person[]): boolean {
    this.people = newPeople
    this.lastUpdated = new Date()

    if (newPeople.length > this.highestCountSinceReset) {
      this.highestCountSinceReset = newPeople.length
    }

    return true
  }

  getHighestCountAndReset(): number {
    const count = this.highestCountSinceReset
    this.highestCountSinceReset = 0
    return count
  }

}
