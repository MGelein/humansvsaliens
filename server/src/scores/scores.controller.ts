import { Controller, Get, Param } from '@nestjs/common'
import { ScoresService } from './scores.service'

@Controller('scores')
export class ScoresController {

  constructor(private readonly scoresService: ScoresService) {}

  @Get()
  list(): Score[] {
    return this.scoresService.list()
  }

  @Get(':id/:score')
  set(@Param('id') id, @Param('score') score): boolean {
    return this.scoresService.add(id, Number(score))
  }

}
