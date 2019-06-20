import { Controller, Get } from '@nestjs/common'
import { LightsService } from './lights/lights.service'
import { PeopleService } from './people/people.service'

@Controller()
export class AppController {
  constructor(private readonly lightsService: LightsService, private readonly peopleService: PeopleService) {}

  @Get()
  index(): any {
    return {
      lights: this.lightsService.list(),
      people: this.peopleService.list()
    }
  }
}
