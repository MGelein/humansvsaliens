import { Controller, Get } from '@nestjs/common'
import { ProgressService } from './progress/progress.service'
import { LightsService } from './lights/lights.service'
import { PeopleService } from './people/people.service'

@Controller()
export class AppController {
  constructor(private readonly progressService: ProgressService, private readonly lightsService: LightsService, private readonly peopleService: PeopleService) {}

  @Get()
  index(): any {
    return {
      progress: this.progressService.get(),
      lights: this.lightsService.list(),
      people: this.peopleService.list()
    }
  }
}
