package com.ssafy.coffee.domain.recipe.controller;

import com.ssafy.coffee.domain.recipe.dto.RecipeGetListResponseDto;
import com.ssafy.coffee.domain.recipe.dto.RecipeGetResponseDto;
import com.ssafy.coffee.domain.recipe.dto.RecipePostRequestDto;
import com.ssafy.coffee.domain.recipe.dto.RecipeUpdateRequestDto;
import com.ssafy.coffee.domain.recipe.service.RecipeService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@Tag(name = "recipe", description = "커피 레시피 API")
@RequestMapping("/api/recipe")
public class RecipeController {

    private final RecipeService recipeService;

    @Operation(summary = "레시피 추가", description = "새로운 레시피 정보를 추가합니다.")
    @ApiResponse(responseCode = "201", description = "레시피가 성공적으로 추가됨")
    @ApiResponse(responseCode = "400", description = "잘못된 요청 데이터")
    @ApiResponse(responseCode = "500", description = "서버 내부 오류")
    @PostMapping
    public ResponseEntity<Object> addRecipe(@ModelAttribute RecipePostRequestDto recipePostRequestDto) {
        recipeService.addRecipe(recipePostRequestDto);
        return ResponseEntity.status(HttpStatus.CREATED).body("Recipe added successfully");
    }

    @Operation(summary = "레시피 조회", description = "레시피 정보를 조회합니다.")
    @ApiResponse(responseCode = "200", description = "레시피 조회에 성공", content = @Content(schema = @Schema(implementation = RecipeGetResponseDto.class)))
    @ApiResponse(responseCode = "404", description = "제공된 recipeIndex로 레시피를 찾을 수 없음")
    @ApiResponse(responseCode = "400", description = "잘못된 요청 데이터")
    @ApiResponse(responseCode = "500", description = "서버 내부 오류")
    @GetMapping("/{recipeIndex}")
    public ResponseEntity<Object> getRecipe(@PathVariable Long recipeIndex) {
        RecipeGetResponseDto recipeGetResponseDto = recipeService.getRecipe(recipeIndex);
        return ResponseEntity.status(HttpStatus.OK).body(recipeGetResponseDto);
    }

    @Operation(summary = "레시피 검색", description = "키워드, 정렬 기준, 페이지, 페이지 크기를 이용하여 레시피를 검색합니다.")
    @ApiResponse(responseCode = "200", description = "레시피 검색 성공", content = @Content(schema = @Schema(implementation = RecipeGetResponseDto.class)))
    @ApiResponse(responseCode = "400", description = "잘못된 요청 데이터")
    @ApiResponse(responseCode = "500", description = "서버 내부 오류")
    @GetMapping("/search")
    public ResponseEntity<Object> searchRecipes(
            @RequestParam(required = false) String keyword,
            @PageableDefault(page = 0, size = 10, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable) {
        RecipeGetListResponseDto recipeGetListResponseDto = recipeService.searchRecipes(keyword, pageable);
        return ResponseEntity.status(HttpStatus.OK).body(recipeGetListResponseDto);
    }

    @Operation(summary = "레시피 수정", description = "기존 레시피 정보를 수정합니다.")
    @ApiResponse(responseCode = "204", description = "레시피가 성공적으로 업데이트됨")
    @ApiResponse(responseCode = "404", description = "제공된 recipeIndex로 레시피를 찾을 수 없음")
    @ApiResponse(responseCode = "400", description = "잘못된 요청 데이터")
    @ApiResponse(responseCode = "500", description = "서버 내부 오류")
    @PutMapping("/{recipeIndex}")
    public ResponseEntity<Object> updateRecipe(@PathVariable Long recipeIndex, @Valid @RequestBody RecipeUpdateRequestDto recipeUpdateRequestDto) {
        recipeService.updateRecipe(recipeIndex, recipeUpdateRequestDto);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).body("Recipe updated successfully");
    }

    @Operation(summary = "레시피 삭제", description = "레시피 정보를 삭제합니다.")
    @ApiResponse(responseCode = "204", description = "레시피가 성공적으로 삭제됨")
    @ApiResponse(responseCode = "404", description = "제공된 recipeIndex로 레시피를 찾을 수 없음")
    @ApiResponse(responseCode = "400", description = "잘못된 요청 데이터")
    @ApiResponse(responseCode = "500", description = "서버 내부 오류")
    @DeleteMapping("/{recipeIndex}")
    public ResponseEntity<Object> deleteRecipe(@PathVariable Long recipeIndex) {
        recipeService.deleteRecipe(recipeIndex);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).body("Recipe deleted successfully");
    }
}
