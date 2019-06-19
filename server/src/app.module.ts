import { Module } from '@nestjs/common'
import { AppController } from './app.controller'

import { LightsController } from './lights/lights.controller'
import { LightsService } from './lights/lights.service'

import { PeopleController } from './people/people.controller'
import { PeopleService } from './people/people.service'

@Module({
  imports: [],
  controllers: [AppController, LightsController, PeopleController],
  providers: [LightsService, PeopleService],
})
export class AppModule {}
