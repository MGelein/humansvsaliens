import { Injectable } from '@nestjs/common'

import { ProgressService } from '../progress/progress.service'

@Injectable()
export class LightsService {
  constructor(private readonly progressService: ProgressService) {}

  numberOfLights: number = 5

  get(id: number): number {
    const totalProgress = this.progressService.get()
    const max = (1 / this.numberOfLights) * id
    const min = max - (1 / this.numberOfLights)

    if (totalProgress >= max) {
      return 1.0
    }

    if (totalProgress <= min) {
      return 0.0
    }

    return (totalProgress - min) * this.numberOfLights
  }

}
