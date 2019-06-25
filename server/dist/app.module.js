"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
const common_1 = require("@nestjs/common");
const app_controller_1 = require("./app.controller");
const lights_controller_1 = require("./lights/lights.controller");
const lights_service_1 = require("./lights/lights.service");
const people_controller_1 = require("./people/people.controller");
const people_service_1 = require("./people/people.service");
const game_module_1 = require("./game.module");
const progress_controller_1 = require("./progress/progress.controller");
const progress_service_1 = require("./progress/progress.service");
let AppModule = class AppModule {
};
AppModule = __decorate([
    common_1.Module({
        imports: [game_module_1.GameModule],
        controllers: [app_controller_1.AppController, lights_controller_1.LightsController, people_controller_1.PeopleController, progress_controller_1.ProgressController],
        providers: [lights_service_1.LightsService, people_service_1.PeopleService, progress_service_1.ProgressService],
    })
], AppModule);
exports.AppModule = AppModule;
//# sourceMappingURL=app.module.js.map