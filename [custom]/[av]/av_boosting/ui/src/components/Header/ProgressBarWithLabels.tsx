import { Box, Text, Progress } from '@mantine/core';
import { useRecoilValue } from 'recoil';
import { Profile } from "../../reducers/atoms";
import classes from './ProgressStyle.module.css'

const ProgressBarWithLabels = () => {
  const profile = useRecoilValue(Profile)
  return (
    <Box 
      display="flex" 
      w="60%" 
      style={{
        alignItems: 'center', 
        justifyContent: 'center', 
        textAlign: 'center'
      }}
    >
      <Text mr="xs" c="gray">{profile.currentClass}</Text>
      <Progress value={profile.level} w="100%" style={{ flex: 1, margin: '0 8px' }} size="sm" classNames={{section: classes.section}}/>
      <Text ml="xs" c="gray">{profile.nextClass}</Text>
    </Box>
  );
};

export default ProgressBarWithLabels;
