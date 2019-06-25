import * as fsStore from 'cache-manager-fs';
import { CacheModule, Module } from '@nestjs/common'
import { AppController } from './app.controller'

import { LightsController } from './lights/lights.controller'
import { LightsService } from './lights/lights.service'

import { PeopleController } from './people/people.controller'
import { PeopleService } from './people/people.service'

import { GameModule } from './game.module';

import { ProgressController } from './progress/progress.controller';
import { ProgressService } from './progress/progress.service';

import { CacheService } from './cache.service';

@Module({
  imports: [GameModule, CacheModule.register({
    store: fsStore,
    options: {
      ttl: 60*60*24*30 /* seconds */,
      maxsize: 1000*1000*1000 /* max size in bytes on disk */,
      path: 'storage',
      preventfill: true
    }
  })],
  controllers: [AppController, LightsController, PeopleController, ProgressController],
  providers: [CacheService, PeopleService, ProgressService, LightsService],
})
export class AppModule {}
