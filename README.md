# Faasos_service_analysis
Introduction
<br>
The Faaso's SQL Portfolio Project involved a comprehensive exploration of the database associated with Faaso, a hypothetical food delivery platform. The project aimed to derive meaningful insights, optimize processes, and enhance decision-making capabilities through extensive SQL queries. The following sections provide a detailed overview of the key aspects addressed in the project.

Project Objectives
1.	Database Creation: Initiated the project by creating a robust and structured database to efficiently manage Faaso's data.
2.	Table Creation and Population: Developed and populated essential tables within the database to ensure the availability of critical data for analysis.
3.	Data Review: Conducted a thorough review of the created tables, ensuring data accuracy and completeness.
4.	Driver Metrics (Roll Metrics): Analyzed various driver-related metrics to evaluate performance and efficiency, providing insights for strategic decision-making.
5.	Driver & Customer Experience Analysis: Explored data to enhance the understanding of both driver and customer experiences, identifying areas for improvement.
6.	Ingredient Optimization: Investigated ingredient data to optimize inventory management and streamline the supply chain.
7.	Pricing & Ratings Analysis: Analyzed pricing and ratings data to derive insights into customer behavior and preferences, contributing to strategic pricing decisions.

Key Queries and Techniques Employed
A. Roll Metrics
1.	Total Rolls Ordered: Utilized COUNT to determine the total number of rolls ordered.
2.	Unique Customer Orders: Employed COUNT and DISTINCT to identify the number of unique customer orders.
3.	Successful Orders Delivered by Each Driver: Leveraged COUNT and GROUP BY to assess successful orders delivered by individual drivers.
4.	Type of Rolls Delivered: Employed conditional logic (CASE WHEN) to categorize rolls as 'ns' (not successful) or 's' (successful) and aggregated the counts.
5.	Rolls Ordered by Each Customer: Utilized JOIN and GROUP BY to determine the count of rolls ordered by each customer.

B. Driver & Customer Experience Analysis
1.	Average Time for Each Driver to Arrive: Calculated the average time for each driver to arrive using TIMEDIFF and ROUND.
2.	Relationship Between Number of Rolls and Time to Prepare: Explored the correlation between the number of rolls and the time taken, providing valuable insights into operational efficiency.
3.	Average Distance Traveled for Each Customer: Calculated the average distance traveled for each customer, providing insights into delivery logistics.

C. Ingredient Optimization
1.	Rolls with Exclusions and Extras: Created views (new_2 and new_3) to analyze the number of rolls with and without changes.
2.	Total Number of Rolls Ordered for Each Hour: Employed CONCAT and GROUP BY to analyze the distribution of orders throughout the day.

Challenges Faced
1.	Data Cleaning: Addressed inconsistencies in data, including handling null values, empty strings, and NaN values for improved accuracy.
2.	Complex Queries: Devised intricate queries involving nested subqueries and conditional logic to extract meaningful insights.
3.	Performance Optimization: Ensured queries were optimized for performance, especially when dealing with large datasets.

Conclusion
The Faaso's SQL Portfolio Project successfully addressed the outlined objectives, providing a comprehensive analysis of various aspects of the food delivery platform. The project showcased proficiency in SQL querying, data analysis, and database management. The insights derived from the project can be instrumental in informing business strategies, optimizing operations, and enhancing the overall user experience.
This documentation serves as a testament to the skills and capabilities demonstrated in handling complex datasets and deriving actionable insights to support data-driven decision-making.
