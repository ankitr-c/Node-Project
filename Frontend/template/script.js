apiCallButton.addEventListener('click', () => {

    fetch('http://localhost:8000/')
      
      .then(response => {
        
        // Check response status
        if(response.status === 200){
          // Success status
          return response.text();  
        } else {
          // Handle error status
          throw new Error('API response status: ' + response.status); 
        }
        
      })
      
      .then(data => {
        apiResponse.innerHTML = data; 
      })
      
      .catch(error => {
        console.error(error);
        apiResponse.innerHTML = 'Error calling API'; 
      });
  
  });