local _, AddOn = ...

print("In Constants.lua ", AddOn)

AddOn.Constants = {
    Alpha = {
        Min = 0.0,
        Max = 1.0,
        Full = 1.0,
        Step = 0.5,
        Tenth = 0.1,
        Quarter = 0.25,
        Half = 0.5
    }, 
    Scale = {
        Min = 0.0,
        Max = 2.0,
        Full = 1.0,
        Step = 0.1,
        Quarter = 0.3,
        Half = 0.5
    }
}
