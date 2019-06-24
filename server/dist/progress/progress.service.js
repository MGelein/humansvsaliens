"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
const common_1 = require("@nestjs/common");
let ProgressService = class ProgressService {
    constructor() {
        this.progress = 0.2;
    }
    get() {
        return this.progress;
    }
    set(newProgress) {
        this.progress = newProgress;
        return true;
    }
};
ProgressService = __decorate([
    common_1.Injectable()
], ProgressService);
exports.ProgressService = ProgressService;
//# sourceMappingURL=progress.service.js.map