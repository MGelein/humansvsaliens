import { Controller, Get, Put, Body } from '@nestjs/common'
import { ProgressService } from './progress.service'

@Controller('progress')
export class ProgressController {
  constructor(private readonly progressService: ProgressService) {}

  @Get()
  get(): number {
    return this.progressService.get()
  }

  @Put()
  update(@Body() body: string): boolean {
    console.log(body)
    console.log(parseFloat(body))
    return this.progressService.set(parseFloat(body))
  }

}
