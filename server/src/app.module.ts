import { Module } from '@nestjs/common'
import { AppController } from './app.controller'

import { LightsController } from './lights/lights.controller'
import { LightsService } from './lights/lights.service'

import { PeopleController } from './people/people.controller'
import { PeopleService } from './people/people.service'

import { GameModule } from './game.module';

import { ProgressController } from './progress/progress.controller';
import { ProgressService } from './progress/progress.service';

@Module({
  imports: [GameModule],
  controllers: [AppController, LightsController, PeopleController, ProgressController],
  providers: [PeopleService, ProgressService, LightsService],
})
export class AppModule {}
