import { Injectable } from '@nestjs/common'

@Injectable()
export class ProgressService {

  progress: number = 0.2

  get(): number {
    return this.progress
  }

  set(newProgress: number): boolean {
    this.progress = newProgress
    return true
  }

}
