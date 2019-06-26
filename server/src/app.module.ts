import { Module } from '@nestjs/common'
import { AppController } from './app.controller'

import { StorageService } from './storage.service';

import { LightsController } from './lights/lights.controller'
import { LightsService } from './lights/lights.service'

import { PeopleController } from './people/people.controller'
import { PeopleService } from './people/people.service'

import { GameModule } from './game.module';

import { ProgressController } from './progress/progress.controller';
import { ProgressService } from './progress/progress.service';

import { ScoresController } from './scores/scores.controller';
import { ScoresService } from './scores/scores.service';

@Module({
  imports: [GameModule],
  controllers: [AppController, LightsController, PeopleController, ProgressController, ScoresController],
  providers: [StorageService, PeopleService, ProgressService, LightsService, ScoresService],
})
export class AppModule {
  
}
