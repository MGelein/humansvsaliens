import { Controller, Get, Param, Query, Header } from '@nestjs/common'
import { ScoresService, Score } from './scores.service'

@Controller('scores')
export class ScoresController {

  constructor(private readonly scoresService: ScoresService) {}

  @Get()
  async list(): Promise<Score[]> {
    return await this.scoresService.list()
  }

  @Get('top/:k')
  @Header('Content-Type', 'text/plain')
  async top(@Param('k') k, @Query() query: any): Promise<Score[] | string> {
    const scores = await this.scoresService.top(Number(k))

    if (query.csv !== undefined) {
      return scores.map((score: Score) => Object.keys(score).map((key: string) => score[key]).join(',')).join('\n')
    }

    return JSON.stringify(scores)
  }

  @Get(':name/:result')
  async set(@Param('name') name, @Param('result') result, @Query() query: any): Promise<Score | string> {
    const score = await this.scoresService.add(name, Number(result))

    if (query.csv !== undefined) {
      return Object.keys(score).map((key: string) => score[key] as string).join(',')
    }

    return score
  }


}
