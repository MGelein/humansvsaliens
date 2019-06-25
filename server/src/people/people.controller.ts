import { Controller, Get, Put, Body, Header } from '@nestjs/common'
import { PeopleService, Person } from './people.service'

@Controller('people')
export class PeopleController {
  constructor(private readonly peopleService: PeopleService) {}

  @Get()
  list(): Person[] {
    return this.peopleService.list()
  }

  @Get('csv')
  @Header('Content-Type', 'text/plain')
  csv(): string {
    return this.peopleService.list().map((person: Person) => Object.keys(person).map((key: string) => person[key]).join(',')).join('\n')
  }
  
  @Put()
  update(@Body() body: any) {
    const newPeople = Object.keys(body).reduce((people: Person[], key: string) => {
      people.push(({ id: Number(key), x: body[key][0], y: body[key][1], w: body[key][2], h: body[key][3] }))
      return people
    }, [])
    
    this.peopleService.update(newPeople)

    return true
  }

}
