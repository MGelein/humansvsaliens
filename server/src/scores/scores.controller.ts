import { Controller, Get, Param } from '@nestjs/common'
import { ScoresService, Score } from './scores.service'

@Controller('scores')
export class ScoresController {

  constructor(private readonly scoresService: ScoresService) {}

  @Get()
  async list(): Promise<Score[]> {
    return await this.scoresService.list()
  }

  @Get('top/:k')
  async top(k: number): Promise<Score[]> {
    return await this.scoresService.top(k)
  }

  @Get(':name/:score')
  async set(@Param('name') name, @Param('score') score): Promise<Score> {
    return await this.scoresService.add(name, Number(score))
  }

}
