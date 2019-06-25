import { NestFactory } from '@nestjs/core'
import { AppModule } from './app.module'

import { Person } from './people/people.service'

async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  // Dummy data
  app.get('LightsService').set(1, 0.3)
  app.get('LightsService').set(2, 0.4)
  app.get('LightsService').set(3, 0.5)
  app.get('LightsService').set(4, 0.6)
  app.get('LightsService').set(5, 0.7)
  app.get('PeopleService').update([
    { id: 0, x: 0.3, y: 0.5, w: 150, h: 500 },
    { id: 1, x: 0.6, y: 0.4, w: 150, h: 400 }
  ])

  await app.listen(3000, () => {
    console.log(`Server listening on localhost:3000`)
    console.log(`Launched on ${new Date()}`)
  })
}

bootstrap()