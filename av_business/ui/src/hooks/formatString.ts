export const formatString = (text: string, replacement: string): string => {
  return text.replace(/%s/g, replacement)
}