import { Injectable } from '@nestjs/common'

import { StorageService } from '../storage.service'

export interface Score {
  id: number;
  name: string;
  score: number;
  recordedAt: Date
}

@Injectable()
export class ScoresService {

  constructor(private readonly storageService: StorageService) {}

  async add(name: string, score: number): Promise<boolean> {
    let scores = await this.storageService.get('scores')

    if (!scores) scores = []

    scores.push({ id: scores.length, name: name, score: score, recordedAt: new Date() } as Score)
    this.storageService.set('scores', scores)

    return true
  }

  async list(): Promise<Score[]> {
    const scores = await this.storageService.get('scores')
    return scores
  }

}
