package com.ssafy.coffee.domain.board.repository;

import com.ssafy.coffee.domain.board.entity.Board;
import com.ssafy.coffee.domain.board.entity.BoardDomain;
import org.springframework.data.repository.query.Param;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface BoardRepository extends JpaRepository<Board, Long> {

    Page<Board> findByTitleContainingAndDomainAndIsDeletedFalse(String title, BoardDomain domain, Pageable pageable);

    Optional<Board> findByIndexAndIsDeletedFalse(Long boardIndex);

    Page<Board> findAllByCreatedByIndexAndIsDeletedFalse(Long memberIndex, Pageable pageable);
}
