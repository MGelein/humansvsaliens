import { Controller, Get, Put, Param, Body } from '@nestjs/common'
import { LightsService } from './lights.service'

@Controller('lights')
export class LightsController {
  constructor(private readonly lightsService: LightsService) {}

  @Get(':id')
  get(@Param('id') id): number {
    return this.lightsService.get(id)
  }
  
}
