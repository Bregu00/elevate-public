import { useState } from "react"
import { Box, Group, Text, Button, TextInput, Select, MultiSelect, NumberInput } from "@mantine/core" 
import { useRecoilValue } from "recoil"
import { Lang } from "../../../reducers/atoms"
import { fetchNui } from "../../../hooks/useNuiEvents"
import classes from './Editor.module.css'

export const EditProduct = ({types, item, ingredients, show, animations, maxIngredients}:any) => {
    const daLang:any = useRecoilValue(Lang);
    const { menu: lang } = daLang
    const [filteredIngredients, setFilteredIngredients] = useState(ingredients.filter((ingredient:any) => ingredient.type.includes(item.type)))
    const [filteredAnimations, setFilteredAnimations] = useState(animations.filter((anim:any) => anim.type.includes(item.type)))
    const [newItem, setNewItem] = useState(item)
    const [parsedIngredients, setParsedIngredients] = useState(item.ingredients)

    const handleSave = () => {
        fetchNui("av_business", "editItem", newItem)
        show(false)
    }
    const updateValue = (field:string, value:any) => {
        if(field == "type") {
            const filteredAnimations = animations.filter((anim:any) => anim.type.includes(value))
            const filteredIngredients = ingredients.filter((ingredient:any) => ingredient.type.includes(value))
            setFilteredAnimations(filteredAnimations)
            setFilteredIngredients(filteredIngredients)
            const clone = {...newItem, prop: null, ingredients: null, type: value}
            setNewItem(clone)
            setParsedIngredients([])
            return
        }
        if(field == "ingredients") {
            const clone = {...newItem, ingredients: value}
            setNewItem(clone)
            setParsedIngredients(value)
            return
        }
        const clone = {...newItem, [field]: value}
        setNewItem(clone)
    }
  return (
    <Box className={classes.mainContainer}>
        <Box className={classes.menuContainer}>
            <Text ta='center' fw={500} size="lg">{lang.edit_header}</Text>
            <Box p={"xs"}>
                <TextInput 
                    label={lang.name}
                    value={newItem.label}
                    size="xs"
                    mt={"xs"}
                    classNames={{
                        input: classes.input
                    }}
                    disabled
                />
                <TextInput 
                    label={lang.productDescription}
                    value={newItem.description}
                    size="xs"
                    mt={"xs"}
                    classNames={{
                        input: classes.input
                    }}
                    onChange={(e)=>{updateValue("description", e.target.value)}}
                />
                <Select
                    label={lang.productType}
                    defaultValue={newItem.type ? newItem.type : null}
                    data={types}
                    size="xs"
                    mt={'xs'}
                    classNames={{
                        input: classes.input,
                        dropdown: classes.dropdown,
                        option: classes.option
                    }}
                    onChange={(e)=>{updateValue("type", e)}}
                />
                <Select
                    label={lang.animation}
                    data={filteredAnimations}
                    value={newItem.prop ? newItem.prop : null}
                    size="xs"
                    mt={'xs'}
                    classNames={{
                        input: classes.input,
                        dropdown: classes.dropdown,
                        option: classes.option
                    }}
                    onChange={(e)=>{updateValue("prop", e)}}
                />
                <MultiSelect
                    label={daLang.ingredients}
                    value={parsedIngredients}
                    data={filteredIngredients}
                    size="xs"
                    mt={'xs'}
                    classNames={{
                        input: classes.input,
                        dropdown: classes.dropdown,
                        option: classes.option,
                        pill: classes.pill
                    }}
                    maxValues={maxIngredients}
                    onChange={(e)=>{updateValue("ingredients", e)}}
                />
                <NumberInput
                    label={lang.suggestedPrice}
                    value={newItem.price ? newItem.price : 0}
                    mt={"xs"}
                    size="xs"
                    classNames={{
                        input: classes.input
                    }}
                    required
                    onChange={(e)=>{updateValue("price", e)}}
                />
                <Group mt={"md"} grow>
                    <Button size="xs" variant="light" color="cyan" onClick={()=>{handleSave()}} disabled={!newItem.type}>{daLang.confirm}</Button>
                    <Button size="xs" variant="light" color="red" onClick={()=>{show(false)}}>{daLang.cancel}</Button>
                </Group>
            </Box>
        </Box>
    </Box>
  )
}