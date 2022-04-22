function elementInSet(set, element)
    for i=1,#set do
        if set[i] == element then
            return true
        end
    end

    return false
end