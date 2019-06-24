"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
const common_1 = require("@nestjs/common");
const progress_service_1 = require("./progress/progress.service");
const lights_service_1 = require("./lights/lights.service");
const people_service_1 = require("./people/people.service");
let AppController = class AppController {
    constructor(progressService, lightsService, peopleService) {
        this.progressService = progressService;
        this.lightsService = lightsService;
        this.peopleService = peopleService;
    }
    index() {
        return {
            progress: this.progressService.get(),
            lights: this.lightsService.list(),
            people: this.peopleService.list()
        };
    }
};
__decorate([
    common_1.Get(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Object)
], AppController.prototype, "index", null);
AppController = __decorate([
    common_1.Controller(),
    __metadata("design:paramtypes", [progress_service_1.ProgressService, lights_service_1.LightsService, people_service_1.PeopleService])
], AppController);
exports.AppController = AppController;
//# sourceMappingURL=app.controller.js.map