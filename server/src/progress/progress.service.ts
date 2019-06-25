import { Injectable } from '@nestjs/common'

import { CacheService } from '../cache.service'

@Injectable()
export class ProgressService {

  constructor(private readonly cacheService: CacheService) {}

  progress: number = 0.2

  get(): number {
    return this.progress
  }

  set(newProgress: number): boolean {
    this.progress = newProgress
    return true
  }

}
