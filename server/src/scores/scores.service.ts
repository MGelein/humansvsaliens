import { Injectable } from '@nestjs/common'

import { CacheService } from '../cache.service'

interface Score {
  id: string;
  score: number;
}

@Injectable()
export class ScoresService {

  constructor(private readonly cacheService: CacheService) {}

  scores: Score[] = []

  add(id: string, score: number): boolean {
    this.scores.push({ id: id, score: score })
    return true
  }

  list(): Score[] {
    return this.scores
  }

}
