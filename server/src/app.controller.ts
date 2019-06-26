import { Controller, Get } from '@nestjs/common'
import { ProgressService } from './progress/progress.service'
import { LightsService } from './lights/lights.service'
import { ScoresService } from './scores/scores.service'
import { PeopleService } from './people/people.service'

@Controller()
export class AppController {
  constructor(private readonly scoresService: ScoresService, private readonly progressService: ProgressService, private readonly lightsService: LightsService, private readonly peopleService: PeopleService) {}

  @Get()
  async index(): Promise<any> {
    return {
      progress: this.progressService.get(),
      lights: {
        1: this.lightsService.get(1),
        2: this.lightsService.get(2),
        3: this.lightsService.get(3),
        4: this.lightsService.get(4),
        5: this.lightsService.get(5),
      },
      people: this.peopleService.list(),
      scores: await this.scoresService.list()
    }
  }
}
