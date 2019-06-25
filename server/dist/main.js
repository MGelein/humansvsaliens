"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const app_module_1 = require("./app.module");
function bootstrap() {
    return __awaiter(this, void 0, void 0, function* () {
        const app = yield core_1.NestFactory.create(app_module_1.AppModule);
        app.get('LightsService').set(1, 0.3);
        app.get('LightsService').set(2, 0.4);
        app.get('LightsService').set(3, 0.5);
        app.get('LightsService').set(4, 0.6);
        app.get('LightsService').set(5, 0.7);
        app.get('PeopleService').update([
            { id: 0, x: 0.3, y: 0.5, w: 150, h: 500 },
            { id: 1, x: 0.6, y: 0.4, w: 150, h: 400 }
        ]);
        yield app.listen(3000, () => {
            console.log(`Server listening on localhost:3000`);
            console.log(`Launched on ${new Date()}`);
        });
    });
}
bootstrap();
//# sourceMappingURL=main.js.map