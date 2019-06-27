import { Injectable } from '@nestjs/common'

import { PeopleService } from '../people/people.service'
import { StorageService } from '../storage.service'

export interface Score {
  id: number;
  rank?: number;
  name: string;
  result: number;
  involvedPeopleCount: number;
  recordedAt: string
}

@Injectable()
export class ScoresService {

  constructor(private readonly storageService: StorageService, private readonly peopleService: PeopleService) {}

  async add(name: string, result: number): Promise<Score> {
    let scores = await this.list()

    const newScore: Score = {
      id: scores.length,
      name: name,
      result: result,
      involvedPeopleCount: this.peopleService.getHighestCountAndReset(),
      recordedAt: new Date().toJSON()
    }
    
    scores.push(newScore)
    this.storageService.set('scores', scores)

    const rankedScore = this.rank(scores).find((score: Score) => {
      return score.id === newScore.id
    })

    return rankedScore
  }

  async list(): Promise<Score[]> {
    const scores = await this.storageService.get('scores')
    if (scores) return scores
    return []
  }

  async top(k: number): Promise<Score[]> {
    const scores = await this.list()
    return this.rank(scores).slice(0, k)
  }

  private rank(scores: Score[]): Score[] {
    const sortedScores = scores.sort((a: Score, b: Score) => b.result - a.result) // sort in descending order
    return sortedScores.map((score: Score, index: number) => { score.rank = index + 1; return score })
  }

}
