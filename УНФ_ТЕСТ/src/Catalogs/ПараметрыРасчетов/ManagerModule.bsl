
#Область ПрограммныйИнтерфейс

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ДополнитьПараметрыРасчета() Экспорт
		
	// Норма дней по графику
	Если НЕ УправлениеНебольшойФирмойСервер.ПараметрРасчетаСуществует("НормаДнейГрафикСотрудника") Тогда
		
		ПараметрРасчетовНормаДней = Справочники.ПараметрыРасчетов.СоздатьЭлемент();
		ПараметрРасчетовНормаДней.Наименование 		 = "Норма дней (график работы сотрудника)";
		ПараметрРасчетовНормаДней.Идентификатор 	 = "НормаДнейГрафикСотрудника";
		ПараметрРасчетовНормаДней.ПроизвольныйЗапрос = Истина;
		ПараметрРасчетовНормаДней.ЗадаватьЗначениеПриРасчетеЗП = Ложь;
		НовыйПараметрЗапроса 						 = ПараметрРасчетовНормаДней.ПараметрыЗапроса.Добавить();
		НовыйПараметрЗапроса.Имя 					 = "ПериодРегистрации";
		НовыйПараметрЗапроса.Представление 			 = "Период регистрации";
		НовыйПараметрЗапроса 						 = ПараметрРасчетовНормаДней.ПараметрыЗапроса.Добавить();
		НовыйПараметрЗапроса.Имя 					 = "ГрафикРаботы";
		НовыйПараметрЗапроса.Представление 			 = "График работы";
		
		ПараметрРасчетовНормаДней.Запрос 			 = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ДЕНЬ(ГрафикиРаботы.ВремяНачала)) КАК НормаДней
		|ИЗ
		|	РегистрСведений.ГрафикиРаботы КАК ГрафикиРаботы
		|ГДЕ
		|	ГрафикиРаботы.ГрафикРаботы = &ГрафикРаботы
		|	И ГрафикиРаботы.ВремяНачала МЕЖДУ НАЧАЛОПЕРИОДА(&ПериодРегистрации, МЕСЯЦ) И КОНЕЦПЕРИОДА(&ПериодРегистрации, МЕСЯЦ)
		|	И ГрафикиРаботы.Год = ГОД(&ПериодРегистрации)";
		
		ПараметрРасчетовНормаДней.Записать();
		
	КонецЕсли;
	
	// Норма часов по графику
	Если НЕ УправлениеНебольшойФирмойСервер.ПараметрРасчетаСуществует("НормаЧасовГрафикСотрудника") Тогда
		
		ПараметрРасчетовНормаЧасов = Справочники.ПараметрыРасчетов.СоздатьЭлемент();
		ПараметрРасчетовНормаЧасов.Наименование 	  = "Норма часов (график работы сотрудника)";
		ПараметрРасчетовНормаЧасов.Идентификатор 	  = "НормаЧасовГрафикСотрудника";
		ПараметрРасчетовНормаЧасов.ПроизвольныйЗапрос = Истина;
		ПараметрРасчетовНормаЧасов.ЗадаватьЗначениеПриРасчетеЗП = Ложь;
		НовыйПараметрЗапроса 						 = ПараметрРасчетовНормаЧасов.ПараметрыЗапроса.Добавить();
		НовыйПараметрЗапроса.Имя 					 = "ПериодРегистрации";
		НовыйПараметрЗапроса.Представление 			 = "Период регистрации";
		НовыйПараметрЗапроса 						 = ПараметрРасчетовНормаЧасов.ПараметрыЗапроса.Добавить();
		НовыйПараметрЗапроса.Имя 					 = "ГрафикРаботы";
		НовыйПараметрЗапроса.Представление 			 = "График работы";
		
		ПараметрРасчетовНормаЧасов.Запрос 			 = 
		"ВЫБРАТЬ
		|	СУММА(ГрафикиРаботы.ЧасыРаботы) КАК НормаЧасов
		|ИЗ
		|	РегистрСведений.ГрафикиРаботы КАК ГрафикиРаботы
		|ГДЕ
		|	ГрафикиРаботы.ГрафикРаботы = &ГрафикРаботы
		|	И ГрафикиРаботы.ВремяНачала МЕЖДУ НАЧАЛОПЕРИОДА(&ПериодРегистрации, МЕСЯЦ) И КОНЕЦПЕРИОДА(&ПериодРегистрации, МЕСЯЦ)
		|	И ГрафикиРаботы.Год = ГОД(&ПериодРегистрации)";
		ПараметрРасчетовНормаЧасов.Записать();
		
	КонецЕсли;
		
КонецПроцедуры
	
#КонецЕсли

#КонецОбласти
