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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
const common_1 = require("@nestjs/common");
const people_service_1 = require("./people.service");
let PeopleController = class PeopleController {
    constructor(peopleService) {
        this.peopleService = peopleService;
    }
    list() {
        return this.peopleService.list();
    }
    csv() {
        return this.peopleService.list().map((person) => Object.keys(person).map((key) => person[key]).join(',')).join('\n');
    }
    update(body) {
        const newPeople = Object.keys(body).reduce((people, key) => {
            people.push(({ id: Number(key), x: body[key][0], y: body[key][1], w: body[key][2], h: body[key][3] }));
            return people;
        }, []);
        this.peopleService.update(newPeople);
        return true;
    }
};
__decorate([
    common_1.Get(),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Array)
], PeopleController.prototype, "list", null);
__decorate([
    common_1.Get('csv'),
    common_1.Header('Content-Type', 'text/plain'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", String)
], PeopleController.prototype, "csv", null);
__decorate([
    common_1.Put(),
    __param(0, common_1.Body()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], PeopleController.prototype, "update", null);
PeopleController = __decorate([
    common_1.Controller('people'),
    __metadata("design:paramtypes", [people_service_1.PeopleService])
], PeopleController);
exports.PeopleController = PeopleController;
//# sourceMappingURL=people.controller.js.map