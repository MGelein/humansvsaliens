import { Controller, Get, Put, Body } from '@nestjs/common'
import { PeopleService, Person } from './people.service'

@Controller('people')
export class PeopleController {
  constructor(private readonly peopleService: PeopleService) {}

  @Get()
  list(): Person[] {
    return this.peopleService.list()
  }
  
  @Put()
  update(@Body() body: any) {
    console.log(body)

    return true
  }

}
