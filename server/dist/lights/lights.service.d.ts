declare type LightStateList = {
    [id: number]: number;
};
export declare class LightsService {
    lightStates: LightStateList;
    list(): LightStateList;
    get(id: number): number;
    set(id: number, newState: number): boolean;
}
export {};
