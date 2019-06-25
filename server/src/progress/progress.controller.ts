import { Controller, Get, Post, Param, Body } from '@nestjs/common'
import { ProgressService } from './progress.service'

@Controller('progress')
export class ProgressController {
  constructor(private readonly progressService: ProgressService) {}

  @Get()
  get(): number {
    return this.progressService.get()
  }

  @Get(':progress')
  set(@Param('progress') progress): boolean {
    return this.progressService.set(Number(progress))
  }

  @Post()
  update(@Body() body: string): boolean {
    return this.progressService.set(Number(Object.keys(body)[0]))
  }

}
