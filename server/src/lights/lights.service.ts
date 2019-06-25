import { Injectable } from '@nestjs/common'

type LightStateList = { [id: number]: number }

@Injectable()
export class LightsService {

  lightStates: LightStateList = {}

  list(): LightStateList {
    return this.lightStates
  }

  get(id: number): number {
    return this.lightStates[id] ? this.lightStates[id] : 0.0
  }

  set(id: number, newState: number): boolean {
    this.lightStates[id] = newState
    return true
  }

}
