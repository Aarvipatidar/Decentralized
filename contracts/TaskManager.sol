// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TaskManager {
    uint256 public taskCount = 0;

    struct Task {
        uint256 id;
        string description;
        bool isCompleted;
        address owner;
    }

    mapping(uint256 => Task) public tasks;

    event TaskCreated(uint256 id, string description, address owner);
    event TaskToggled(uint256 id, bool isCompleted);
    event TaskDeleted(uint256 id);

    modifier onlyOwner(uint256 _taskId) {
        require(tasks[_taskId].owner == msg.sender, "Not the task owner.");
        _;
    }

    function createTask(string calldata _description) external {
        taskCount++;
        tasks[taskCount] = Task(taskCount, _description, false, msg.sender);
        emit TaskCreated(taskCount, _description, msg.sender);
    }

    function toggleTaskCompletion(uint256 _taskId) external onlyOwner(_taskId) {
        Task storage task = tasks[_taskId];
        task.isCompleted = !task.isCompleted;
        emit TaskToggled(_taskId, task.isCompleted);
    }

    function deleteTask(uint256 _taskId) external onlyOwner(_taskId) {
        delete tasks[_taskId];
        emit TaskDeleted(_taskId);
    }

    function getTask(uint256 _taskId) external view returns (Task memory) {
        return tasks[_taskId];
    }

    // ✅ New function: Returns all tasks owned by the caller
    function getMyTasks() external view returns (Task[] memory) {
        uint256 count = 0;

        // Count how many tasks the caller owns
        for (uint256 i = 1; i <= taskCount; i++) {
            if (tasks[i].owner == msg.sender) {
                count++;
            }
        }

        // Collect the tasks
        Task[] memory myTasks = new Task[](count);
        uint256 index = 0;

        for (uint256 i = 1; i <= taskCount; i++) {
            if (tasks[i].owner == msg.sender) {
                myTasks[index] = tasks[i];
                index++;
            }
        }

        return myTasks;
    }
}
